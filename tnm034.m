function strout = tnm034(im) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 
% 
%   OMR Project, Abob, Gabriel Berthold & Jonas Kinnvall
    str = '';
    %strout = '';
    image = im2double(im);

    %Create array of every relevant quarternote
    qNotes = ["E4","D4","C4","B3","A3","G3","F3","E3","D3","C3","B2","A2","G2","F2","E2","D2","C2","B1","A1","G1"];
    eNotes = ["e4","d4","c4","b3","a3","g3","f3","e3","d3","c3","b2","a2","g2","f2","e2","d2","c2","b1","a1","g1"];

    %Binarize image and call calcRotation function to get rotation angle
    binThresh = 0.75;
    rotIm = 1 - imbinarize(image(:,:,1), binThresh);

    staffAngle = calcRotation(rotIm);
    %figure();
    %imshow(rotIm);

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
    std(h,1);
    mean(h);
    peakThresh = mean(h)+ 2* std(h,1);
    peakFiltered = (h>peakThresh);

    % figure;
    % plot(h)
    % hold on;
    % plot(peakFiltered)

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
        %figure;
        %imshow(binIm);

        h2 = mean(binIm,2);

        peakThresh2 = mean(h2)+ 2* std(h2,1);
        peakFiltered2 = (h2>peakThresh2);

        [staffPks, staffLocs] = findpeaks(double(peakFiltered2));
        %size(pks2)
        noteDist = (staffLocs(5) - staffLocs(1))/9;

        noteLocs  = zeros(1,20);
        nl=1;

        for i=(staffLocs(1)-6*noteDist):noteDist:(staffLocs(5)+5*noteDist)
           noteLocs(nl)=i;
           nl=nl+1;
        end


        %plot(h, 1:size(h))
        %figure(); imshow(binIm);
        %hold on; 
        %for i=1:size(locs,1)
        %    plot([1;size(image,2)],[locs(i,1);locs(i,1)],'r');
        %end
        %hold off;

        %Scan binaryImage and remove staffs where there are no notes intersecting 
        for i=1:size(peakFiltered2,1)
            if(peakFiltered2(i,1) == 1 )
                for j=1:columns
                    if(binIm(i-1,j,:) == 0)
                        binIm(i,j,:)=0;              
                    end
                end
            end 
        end

        %figure;
        %imshow(binIm);

        %Erosion followed by dilation with disk structure to only show notes
        se = strel('disk', 4);
        binImNote = imopen(binIm,se);

        %Extra erosion to separate notes close to each other
        se = strel('disk', 2);
        binImNote = imerode(binImNote,se);

        %figure;
        %imshow(binImNote)

        %Label all notes and find location of note heads with regionprops
        noteLabels = bwlabel(binImNote, 4);

        noteHeads = regionprops(noteLabels, 'centroid');
        noteCents = cat(1, noteHeads.Centroid);


        %Plot note head positions over binary image
        figure;
        imshow(binIm);
        hold on;
        plot(noteCents(:,1), noteCents(:,2), 'b*');
        hold off

        %Creating image segment for every note to compare with templates
        for i=1:size(noteCents,1)

            I = binIm(:, floor((noteCents(i,1)-10:noteCents(i,1)+25)));
    %         figure;
    %         imshow(I); 

            [minDist,index] = min(abs(noteLocs-noteCents(i,2)));

            str =[str, qNotes(index)];

        end
        str =[str,'n'];
        lineindex = lineindex+5;
    end
    str(1) = [];
    str(end) = [];
    %strout = strcat(strout, str);
    strout = strjoin(str);
end

