class Api::V1::ProfilesController < Api::V1::BaseController
    resource_description do
        short 'Users information resources'
        formats ['json']
    end

    api :GET, '/v1/profiles/me.json?access_token=TOKEN', 'Returns the information about the currently logged user'
    error code: 401, desc: 'Unauthorized'
    example "profile: {'id':8,'email':'testing'}"
    def me
        render json: { profile: UserSerializer.new(current_resource_owner) }
    end
end