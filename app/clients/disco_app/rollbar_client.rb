require 'rest-client'

class DiscoApp::RollbarClient

  API_URL = 'https://api.rollbar.com/api/1'
  CREATE_PROJECT_ENDPOINT = '/projects'
  ACCESS_TOKEN_ENDPOINT = '/project'
  ACCESS_TOKEN_SCOPE = 'post_server_item'

  def initialize(params)
    @write_access_token = params[:write_account_access_token]
    @read_access_token = params[:read_account_access_token]
  end

  # Create project on Rollbar, returns it new post server side access token
  def create_project(name)
    begin
      response = RestClient::Request.execute(
        method: :post,
        headers: { content_type: :json },
        url: create_api_url,
        payload: { name: name.parameterize }.to_json
      )
      request_access_token(ActiveSupport::JSON.decode(response).dig('result', 'id'))
    rescue RestClient::BadRequest => e
      raise RollbarClientError.new(e.message)
    end
  end

  private

    def request_access_token(project_id)
      begin
        response = RestClient.get(access_tokens_api_url(project_id))
        # Only return post_server_item server side access token
        post_server_access_token(ActiveSupport::JSON.decode(response)['result'])
      rescue RestClient::BadRequest => e
        raise RollbarClientError.new(e.message)
      end
    end

    def create_api_url
      API_URL + CREATE_PROJECT_ENDPOINT + "?access_token=#{@write_access_token}"
    end

    def access_tokens_api_url(project_id)
      API_URL + ACCESS_TOKEN_ENDPOINT + "/#{project_id}/access_tokens?access_token=#{@read_access_token}"
    end

    def post_server_access_token(results)
      results.select { |x| x['name'] == ACCESS_TOKEN_SCOPE }.first['access_token']
    end
end
