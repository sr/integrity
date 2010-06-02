module Integrity
  class App < Sinatra::Base
    set     :root, File.expand_path("../../..", __FILE__)
    enable  :methodoverride, :static, :sessions
    disable :build_all

    register Mustache::Sinatra
    helpers  Integrity::Helpers

    set :mustache,
      :templates => File.join(root, "templates"),
      :namespace => Integrity

    not_found do
      status 404
      show :not_found, :title => "lost, are we?"
    end

    error do
      @error = request.env["sinatra.error"]
      status 500
      show :error, :title => "something has gone terribly wrong"
    end

    before do
      halt 404 if request.path_info.include?("favico")

      # The browser only sends http auth data for requests that are explicitly
      # required to do so. This way we get the real values of +#logged_in?+ and
      # +#current_user+
      login_required if session[:user]

      unless Integrity.base_url
        Integrity.configure { |c| c.base_url url_for("/", :full) }
      end
    end

    post "/:endpoint/:token" do |endpoint, token|
      pass unless endpoint_enabled?
      halt 403 unless token   == endpoint_token
      halt 400 unless payload =  endpoint_payload

      BuildableProject.call(payload).each { |b| b.build }.size.to_s
    end

    get "/?" do
      @projects = authorized? ? Project.all : Project.all(:public => true)
      show :home, :title => "projects"
    end

    get "/login" do
      login_required

      session[:user] = current_user
      redirect root_url.to_s
    end

    get "/new" do
      login_required

      @project = Project.new
      show :new, :title => ["projects", "new project"]
    end

    post "/?" do
      login_required

      @project = Project.new(params[:project_data])

      if @project.save
        update_notifiers_of(@project)
        redirect project_url(@project).to_s
      else
        show :new, :title => ["projects", "new project"]
      end
    end

    get "/:project" do
      login_required unless current_project.public?
      show :project, :title => ["projects", current_project.name]
    end

    put "/:project" do
      login_required

      if current_project.update(params[:project_data])
        update_notifiers_of(current_project)
        redirect project_url(current_project).to_s
      else
        show :new, :title => ["projects", current_project.permalink, "edit"]
      end
    end

    delete "/:project" do
      login_required

      current_project.destroy
      redirect root_url.to_s
    end

    get "/:project/edit" do
      login_required

      show :new, :title => ["projects", current_project.permalink, "edit"]
    end

    get "/:project/fork" do
      login_required
      mustache :fork, :title => ["projects", current_project.permalink, "fork"]
    end

    post "/:project/fork" do
      login_required

      branch  = params["project_data"]["branch"]
      project = current_project.fork(branch)
      redirect project_url(project).to_s
    end

    post "/:project/builds" do
      login_required

      @build = current_project.build("HEAD")
      redirect build_url(@build).to_s
    end

    get "/:project/builds/:build" do
      login_required unless current_project.public?
      show :build, :title => ["projects", current_project.permalink,
        current_build.commit.short_identifier]
    end

    post "/:project/builds/:build" do
      login_required

      @build = current_project.build(current_build.commit.identifier)
      redirect build_url(@build).to_s
    end

    delete "/:project/builds/:build" do
      login_required

      url = project_url(current_build.project).to_s
      current_build.destroy!
      redirect url
    end
  end
end
