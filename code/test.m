function [] = test()
    i=1;
    while(1)
        i=i+1
        check(); 
    end
end 

function [] = check()
   pause(0.5);
   if waitforbuttonpress == 1
       display('button press');
   end
   
end 

