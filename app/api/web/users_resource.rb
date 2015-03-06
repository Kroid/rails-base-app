class Web::UsersResource < Web
  namespace :users do

    helpers do
      def create_params
        declared(params).slice(:email, :password)
      end

      def device_params
        declared(params).slice(:uuid, :platform).merge(user_id: @user.id)
      end
    end


    desc 'Create user'
    params do
      requires :email,    type: String
      requires :password, type: String
      requires :platform, type: String, values: ['browser', 'ios', 'android']
      requires :uuid,     type: String
    end
    post '/', jbuilder: 'users/create.json' do
      @user = User.new(create_params)

      unless @user.save
        error_422! @user.errors
      end

      @device = Device.create_session device_params

      if @device.errors.present?
        error_422!(@device.errors)
      end
    end

  end
end
