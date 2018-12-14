function [str, beamRight, dBeam, i] = noteDetUp(temp, noteCents, i, noteLocs, index, beamRight, dBeam)
%Function to detect the note type above noteheads by examining the peaks
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
        
    %If vertical projection gives 1 or less peaks, do a 
    %horizontal projection to look for beams    
    elseif(size(vpks,2) < 2)
        
        %Find peaks of horizontal projection
        hTemp = sum(temp,2);

        hpt = max(hTemp)*0.75;
        hpf = (hTemp>hpt);

        [hpks, hlocs] = findpeaks(double(hpf));

        %If there is one horizontal peak the note has a beam, thus an
        %eigthnote
        if(size(hpks,1) == 1)
            
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
            
        %If there are no peaks the note is a quarter note
        elseif(size(hpks,1) == 0)
            
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
        end
    end
end

