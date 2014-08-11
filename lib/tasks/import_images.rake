desc "This task is called by the Heroku cron add-on"
task :import_images => :environment do
  image_files = Dir.entries(Rails.public_path.join('photoshoot')).select {|file| file.downcase.end_with?('.jpg') }
  image_files.each do |file|
    params = ActionController::Parameters.new(path: "photoshoot/#{file.to_s}")
    image = Image.create(params.permit(:path))
  end
end
