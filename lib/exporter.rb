class Exporter

  def initialize app_name
    @checker = Checker.new [:tmp_container,:export]
    @app_name = app_name

    @base_dir = "apps/#{app_name}/"
    #@cmd = '/lib/systemd/systemd'
    @cmd = ENTRYPOINT
    @container_name = "temp-#{app_name}"
  end

  def export
    puts_ln "Exporting image"

    image_name = "gex-#{@app_name}"

    d_rm @container_name

    puts_ln "Creating temp container"
    @checker.res[:tmp_container] = d_run image_name, @container_name, @cmd, " -d --privileged"

    d_stop @container_name

    puts_ln "Exporting"
    tar_file = "#{@base_dir}distributive/#{@app_name}.tar"
    @checker.res[:export] = d_export @container_name,tar_file
    execute_cmd "gzip #{tar_file}"

    d_rm @container_name

    puts_ln "Export done!" if @checker.check
  end

end