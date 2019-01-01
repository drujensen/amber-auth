module Amber::CLI
  class Auth < Generator
    directory "#{__DIR__}/../templates/auth"

    def initialize(name, fields)
      fields += "email:string hashed_password:password"
      super(name, fields)
      add_timestamp_fields
    end

    def pre_render(directory)
      add_routes
      add_plugs
      add_dependencies
      inject_application_controller_methods
    end

    private def add_routes
      add_routes :web, <<-ROUTES
        get "/profile", #{class_name}Controller, :show
        get "/profile/edit", #{class_name}Controller, :edit
        patch "/profile", #{class_name}Controller, :update

        get "/signin", SessionController, :new
        post "/session", SessionController, :create
        get "/signout", SessionController, :delete

        get "/signup", RegistrationController, :new
        post "/registration", RegistrationController, :create
      ROUTES
    end

    private def add_plugs
      add_plugs :web, <<-PLUGS
        plug Authenticate.new
      PLUGS
    end

    private def add_dependencies
      add_dependencies <<-DEPENDENCY
      require "../src/models/**"
      require "../src/pipes/**"
      DEPENDENCY
    end

    private def inject_application_controller_methods
      filename = "./src/controllers/application_controller.cr"
      controller = File.read(filename)
      append_text = ""

      unless controller.includes? "property current_#{@name}"
        append_text += current_method_definition
      end

      unless controller.includes? "def signed_in?"
        append_text += signed_in_method_definition
      end

      append_text = "#{append_text}\nend\n"
      controller = controller.gsub(/end\s*\Z/, append_text)
      File.write(filename, controller)
    end

    private def current_method_definition
      <<-AUTH

        def current_#{@name}
          context.current_#{@name}
        end\n
      AUTH
    end

    private def signed_in_method_definition
      <<-AUTH

        def signed_in?
          current_#{@name} ? true : false
        end\n
      AUTH
    end
  end
end
