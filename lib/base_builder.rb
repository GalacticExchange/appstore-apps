

def build_base_images
  base_images_dir = File.join(Dir.pwd,'base-images')

  chdir base_images_dir

  folders =  Dir.glob('*').select {|f| File.directory? f}
  folders.each do |img|

    path = File.join(base_images_dir,img)
    build_base_image(img,path)

  end

end


def build_base_image(img, path)
  build_script = 'build.sh'

  puts_ln "Building #{img}"

  chdir path

  if File.exist?(build_script)
    sh_build
  else
    puts_err "Cannot find build.sh, trying Dockerfile"
    if File.exist?('Dockerfile')
      d_build(img)
    else
      puts_err "Unable to build #{img}. No build.sh or Dockerfile in folder"
    end
  end

end
