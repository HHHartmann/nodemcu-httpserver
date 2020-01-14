local renameIfNeeded = function(f)
   if file.open(f) then
      file.close()
      print('Renaming:', f)
      local newName = 'http/'..f
      if file.open(newName) then
         file.close()
      file.remove(newName)
      end
      file.rename(f, newName)
   end
end

local dataFiles = {
--   'error404',
   'TicTacToe.css',
   'TicTacToe.html',

   'args.lua',
   'cars-bugatti.jpg',                
   'cars-ferrari.jpg',
   'cars-lambo.jpg',
   'cars-mas.jpg',
   'cars-mercedes.jpg',
   'apple-touch-icon.png',
   'cars-porsche.jpg',
   'cars.html',
   'cars.lua',
   'counter.html',
   'file_list.lua',
   'garage_door_opener.css',
   'garage_door_opener.html',
   'garage_door_opener.lua',
   'hello_world.txt',
   'index.html',
   'node_info.lua',
   'post.lua',
   'underconstruction.gif',
   'upload.html',
   'upload.lua',
   'zipped.html.gz',
}
for i, f in ipairs(dataFiles) do renameIfNeeded(f) end

renameIfNeeded = nil
dataFiles = nil
collectgarbage()

