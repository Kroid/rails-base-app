class Web::SessionsResource < Web
  namespace :sessions do

    helpers do
      def declared_params
        declared(params)
      end

      def device_params
        declared_params.slice(:uuid, :platform).merge(user_id: @user.id)
      end
    end

    desc 'Create session'
    params do
      requires :email,    type: String
      requires :password, type: String
      requires :platform, type: String, values: ['browser', 'ios', 'android']
      requires :uuid,     type: String
    end
    post '/', jbuilder: 'sessions/create.json' do
      @user = User.find_by_email(declared_params[:email])

      unless @user.present? and @user.authenticate(params[:password])
        error_422!('base' => ['something_wrong'])
      end

      @device = Device.create_session device_params

      if @device.errors.present?
        error_422!(@device.errors)
      end
    end


    desc 'Destroy session'
    delete '/', jbuilder: 'sessions/destroy.json' do
      @device = current_device
      @device.update_authentication_token if @device.present?
    end
  end
end
