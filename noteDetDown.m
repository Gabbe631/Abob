function [str, beamRight, dBeam, i] = noteDetDown(temp, noteCents, i, noteLocs, index, beamRight, dBeam)
%Function to detect the note type underneath noteheads by examining the peaks
%obtained through a vertical projection and then through a horizontal
%projection

    str = '';

    
    %Create array of every relevant quarternote and eigthnote
    qNotes = ["E4","D4","C4","B3","A3","G3","F3","E3","D3","C3","B2","A2","G2","F2","E2","D2","C2","B1","A1","G1"];
    eNotes = ["e4","d4","c4","b3","a3","g3","f3","e3","d3","c3","b2","a2","g2","f2","e2","d2","c2","b1","a1","g1"];
    
    %Do vertical projection and find peaks
    vTemp = mean(temp,1);                    

    vpt = max(vTemp)/4;
    vpf = (vTemp>vpt);

    [vpks, vlocs] = findpeaks(double(vpf));

    %If the vertical projection gives 2 peaks there is a flag and thus an
    %eightnote
    if(size(vpks,2) == 2)
        
        %If the note after this one is located underneath this one it is a
        %chord note and thus the same, add both to string and skip the next
        %one in the iteration, else just add the current note to string
        if(i ~= size(noteCents,1) && min(abs(noteCents(i+1,1)-noteCents(i,1)))<3)

            str =[str, eNotes(index)];
            i = i+1;
            [minDist,tempindex] = min(abs(noteLocs-noteCents(i,2)));

            str =[str, eNotes(tempindex)];
        else
            str =[str, eNotes(index)];
        end
        
    %If vertical projection gives 1 or less peaks, do a 
    %horizontal projection to look for beams  
    elseif(size(vpks,2) < 2)

        %Find peaks of horizontal projection
        hTemp = sum(temp,2);

        hpt = max(hTemp)*0.75;
        hpf = (hTemp>hpt);

        [hpks, hlocs] = findpeaks(double(hpf));

        %If there is two horizontal peaks the note has a doublebeam, thus an
        %sixteenth note and should not be counted, beamRight boolean and
        %dBeam should be set to true
        if(size(hpks,1) > 1)
            beamRight = true;
            dBeam = true;
            
        %If there are no peaks but dBeam is true both beamRight and dBeam
        %is set to false (it is the end of a beam)
        elseif(size(hpks,1) == 0 && dBeam == true)
            beamRight = false;
            dBeam = false;
            
        %If there is one horizontal peak or beamRight is true, the note has a beam, thus an
        %eigthnote
        elseif(size(hpks,1) == 1 || beamRight == true)
            
            %If the note after this one is located underneatch this one it is a
            %chord note and thus the same, add both to string and skip the next
            %one in the iteration, else just add the current note to string
            if(i ~= size(noteCents,1) && min(abs(noteCents(i+1,1)-noteCents(i,1)))<3)

                str =[str, eNotes(index)];
                i = i+1;
                [minDist,tempindex] = min(abs(noteLocs-noteCents(i,2)));

                str =[str, eNotes(tempindex)];
            else
                str =[str, eNotes(index)];
            end
            
            %If there is a horizontal peak and beam right is true beamright
            %should stay true (middle note in more than 2 note beam),
            %elseif beamRight is false it should be set to true (first note
            %in beam), else set beamRight to false (last note of beam)
            if(size(hpks,1) == 1 && beamRight == true)
                beamRight = true;            
            elseif(beamRight == false)
                beamRight = true;
            else
                beamRight = false;
            end
        %If there are no peaks and beamRight is false the note is a quarter
        elseif(size(hpks,1) == 0 && beamRight == false)
            
            %If the note after this one is located underneatch this one it is a
            %chord note and thus the same, add both to string and skip the next
            %one in the iteration, else just add the current note to string
            if(i ~= size(noteCents,1) && min(abs(noteCents(i+1,1)-noteCents(i,1)))<3)

                str =[str, qNotes(index)];
                i = i+1;
                [minDist,tempindex] = min(abs(noteLocs-noteCents(i,2)));

                str =[str, qNotes(tempindex)];
            else
                str =[str, qNotes(index)];
            end
            beamRight = false;
        end
    end
end

