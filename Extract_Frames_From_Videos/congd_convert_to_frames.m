
partitions = {'train','valid','test'};


for m = 1:numel(partitions)
	
	partition = partitions{m};
	
	if isequal(partition, 'train')
		load ConGD_Train_Labels
	elseif isequal(partition, 'valid')
		load ConGD_Valid_Labels
	elseif isequal(partition, 'test') 
		load ConGD_Test_Labels
	end
	
	dbPath = ['<SET_IT_TO_DATABASE_PATH>/', partition];
	savePath = ['<SET_IT_TO_SAVE_PATH>/', partition];
	
	
	for i = 1:numel(Labels) 
		
		curr_sample = [dbPath, '/', Labels(i).FolderID, '/', Labels(i).FileID, '.M.avi'];
		currSaveDir = [savePath,'/', Labels(i).FolderID, '/', Labels(i).FileID, '/color/'];
		
		disp(currSaveDir);
		mkdir(currSaveDir);
		
		tic
		cmdstr = ['ffmpeg -i "', curr_sample, '" -q:v 1 ', currSaveDir,'%06d.jpg'];
		[~,~] = system(cmdstr);
		
		curr_images = dir(currSaveDir);
		curr_images([curr_images.isdir]) = [];
		nFrames = numel(curr_images);
		
		for f = 1:nFrames
			s = [currSaveDir,sprintf('%06d', f), '.jpg'];
			d = [currSaveDir,sprintf('%06d', f-1), '.jpg'];

			movefile(s,d);
		end
		toc
	end
end
