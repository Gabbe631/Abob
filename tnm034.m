function strout = tnm034(im) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 
% 
%   OMR Project, Abob, Gabriel Berthold & Jonas Kinnvall
    strout = '';
    image = im2double(im);

    %Binarize image and call calcRotation function to get rotation angle
    binThresh = 0.75;
    rotIm = 1 - imbinarize(image(:,:,1), binThresh);

    staffAngle = calcRotation(rotIm);

    %Rotate image with calculated angle
    if(staffAngle ~= 0)
        image = imrotate(image, -staffAngle, 'bicubic', 'crop');
    end

    %Binarize image and crop artifacts from rotation
    BinaryImage = 1-imbinarize(image(:,:,1), binThresh);

    cropH = tan(deg2rad(abs(staffAngle))) * size(image,2);
    cropW = tan(deg2rad(abs(staffAngle))) * size(image,1);

    rect = [cropW, cropH, size(BinaryImage, 2) - 2*cropW, size(BinaryImage,1) - 2*cropH];

    BinaryImage = imcrop(BinaryImage, rect); 

    %Calculate peak values of binarized image
    h = mean(BinaryImage,2);

    %Create threshhold value to filter peaks
    peakThresh = mean(h)+ 2* std(h,1);
    peakFiltered = (h>peakThresh);

    [pks, locs] = findpeaks(double(peakFiltered));

    %Variables to use in main for-loop
    [rows,columns] = size(BinaryImage);
    dist = floor((locs(6) - locs(5))/2);
    nrIm = size(pks,1)/5;
    lineindex = 1;

    %Main loop to segment image and process each segment individually
    for(i=1:nrIm)

        if((locs(lineindex)-dist)<1)
            binIm = BinaryImage(1:(locs(lineindex+4)+dist), :); 
        else
            if((locs(lineindex+4)+dist)>rows)
                binIm = BinaryImage((locs(lineindex)-dist):rows, :);
            else
                binIm = BinaryImage((locs(lineindex)-dist):(locs((lineindex+4))+dist), :);
            end
        end
        
        %Find peaks for segmented image to calculate height of staff
        %and later note locations
        h2 = mean(binIm,2);

        peakThresh2 = mean(h2)+ 2* std(h2,1);
        peakFiltered2 = (h2>peakThresh2);
        
        [staffPks, staffLocs] = findpeaks(double(peakFiltered2));
           
        %Compute distance between staff line and staff space
        %by taking the distance between first and last staff line and
        %divide by 9 (5 lines and 4 spaces = 9 locations)
        noteDist = (staffLocs(5) - staffLocs(1))/9;
  
        %Scan binaryImage and remove staffs where there are no notes intersecting 
        for k=1:size(staffLocs)
            for j=(staffLocs(k)-1):(staffLocs(k)+(round(noteDist)/2))
                for l=1:columns
                    if(binIm(j-1,l) == 0)
                         binIm(j,l)=0;
                    end
                end
            end
        end
        
        %Array of zeros to be filled with indexes 1-20 corresponding to the
        %relevant notes of the project
        noteLocs  = zeros(1,20);
        
        nl=1;
        for k=((staffLocs(1)-6*noteDist)+1.75):noteDist:((staffLocs(5)+5*noteDist)+1.75)
           noteLocs(nl)=k;
           nl=nl+1;
        end
        
        %Erosion followed by dilation with disk structure to only show notes
        se = strel('disk', round(noteDist));
        binImNote = imopen(binIm,se);

        %Extra erosion to separate notes close to each other
        se = strel('disk', round(noteDist/2));
        binImNote = imerode(binImNote,se);

        %Label all notes and find location of note heads with regionprops
        noteLabels = bwlabel(binImNote, 4);

        noteHeads = regionprops(noteLabels, 'centroid');
        noteCents = cat(1, noteHeads.Centroid);
       
        %Booleans used to detect correct notes
        beamRight = false;
        doubleBeam = false;
        lookUp = false;
        

        i=1;
        while i<=size(noteCents,1)
            
            %Computing which possible note locations along the staffline
            %the current note is closes to
            [minDist,index] = min(abs(noteLocs-noteCents(i,2)));
            
            %Creating image segment for every note to compare with templates                
            I = binIm(:, floor((noteCents(i,1)-noteDist:noteCents(i,1)+5*noteDist)));
            [rowsI, colsI] = size(I);
            
            if(floor(noteCents(i,2))<=staffLocs(3))
                
                %Look Up in special case, else look down                  
                if((beamRight == true && lookUp == true) || (ceil(noteCents(i,2)) == staffLocs(3) && (i ~= size(noteCents,1) && min(abs(noteCents(i+1,1)-noteCents(i,1)))<3 && noteCents(i+1)>staffLocs(3))))
                    
                    %Segment image even further to look above notehead
                    temp = I(floor(1:noteCents(i,2)), :);
                    
                    %Call function to detect note type above notehead
                    [str, beamRight2, dBeam, j] = noteDetUp(temp, noteCents, i, noteLocs, index, beamRight, doubleBeam);

                    beamRight = beamRight2;
                    doubleBeam = dBeam;
                    i=j;
                else
                    %Segment image even further to look underneath notehead
                    temp = I(ceil(noteCents(i,2):noteCents(i,2)+9*noteDist), :);
                    
                    %Call function to detect note type underneath note head
                    [str, beamRight2, dBeam j] = noteDetDown(temp, noteCents, i, noteLocs, index, beamRight, doubleBeam);

                    beamRight = beamRight2;
                    doubleBeam = dBeam;
                    lookUp = false;
                    i=j;
                end
            elseif(ceil(noteCents(i,2))>staffLocs(3))
                
                %Look down in special case, else look up 
                if(beamRight == true && lookUp == false)
                    
                    %Segment image even further to look underneath notehead
                    temp = I(ceil(noteCents(i,2):rowsI), :);
                    
                    %Call function to detect note type underneath note head
                    [str, beamRight2, dBeam j] = noteDetDown(temp, noteCents, i, noteLocs, index, beamRight, doubleBeam);

                    doubleBeam = dBeam;
                    beamRight = beamRight2;
                    i=j;
                else
                    %Segment image even further to look above notehead
                    temp = I(floor(noteCents(i,2)-9*noteDist:noteCents(i,2)), :);
                    
                    %Call function to detect note type above note head
                    [str, beamRight2, dBeam, j] = noteDetUp(temp, noteCents, i, noteLocs, index, beamRight, doubleBeam);

                    beamRight = beamRight2;
                    doubleBeam = dBeam;
                    lookUp = true;
                    i=j;
                end
            end
            strout = [strout, str];
            i = i+1;
        end
        strout =[strout,'n'];
        lineindex = lineindex+5;
    end
    strout(cellfun('isempty', strout)) = [];
    strout(end) = [];
    strout = strjoin(strout, '');
end

