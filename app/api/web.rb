class Web < Grape::API
  formatter :json, Grape::Formatter::Jbuilder

  before do
    env['api.tilt.root'] = 'app/views/api/web'

    header 'Content-Type', 'application/json; charset=utf-8'
  end

  def self.inherited(subclass)
    super

    helpers do
      def current_device
        return @current_device if defined?(@current_device)

        if params[:authentication_token].present?
          headers['X-Authentication-Token'] = params[:authentication_token]
        end

        return unless headers['X-Authentication-Token'].present?
        @current_device = Device.find_by(:authentication_token => headers['X-Authentication-Token'])
      end

      def error_400!()
        resp = {
          :code => 400,
          :message => "bad_request"
        }

        error!(resp, 400 )
      end

      def error_401!()
        resp = {
          :code => 401,
          :message => 'unauthorized',
          :errors => {}
        }

        error!(resp, 401)
      end

      def error_403!(errors = {})
        content = {
          :code => 403,
          :message => "access_denied",
          :errors => errors
        }
        error!(content, 403)
      end

      def error_404!()
        resp = {
          :code => 404,
          :message => "not_found",
          :errors => []
        }

        error!(resp, 404)
      end

      def error_422!(errors = {})
        resp = {
          :code => 422,
          :message => 'unprocessable_entity',
          :errors => errors
        }

        error!(resp, 422)
      end

      def error_500!(errors = {})
        resp = {
          :code => 500,
          :message => 'internal_server_error',
          :errors => errors
        }

        error!(resp, 500)
      end
    end
  end

  mount Web::SessionsResource
  mount Web::UsersResource
end
