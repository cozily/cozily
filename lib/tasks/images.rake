namespace :images do
  task :migrate => :environment do
    Apartment.all.each do |apartment|
      apartment.images.each do |image|
        path = image.asset.path(:original)
        if File.exist?(path)
          upload = ActionDispatch::Http::UploadedFile.new({
            :filename => path.split("/").last,
            :tempfile => File.open(path)
          })
          apartment.photos.create(:image => upload)
          putc '*'
        else
          putc '-'
        end
      end
    end
  end
end
