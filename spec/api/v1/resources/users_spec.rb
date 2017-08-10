describe SPEC_API::Resources::Users, :type => :request do
  describe 'GET /users/me' do
    let(:user) { create(:user) }

    it 'should get the current user if authorized' do
      login_as user
      get '/api/v1/users/me'
      expect(response).to be_success
      expect(response.body).to represent(SPEC_API::Entities::User, user, { full: true })
    end

    it 'should NOT get the current user if unauthorized' do
      get '/api/v1/users/me'
      expect(response.status).to eq(401)
    end
  end

  describe 'PUT /users/:user_id' do
    let(:user) { create(:user, password: 'TestPassword') }
    let(:admin_user) { create(:user, :admin) }
    let(:other_user) { create(:user) }

    context 'as the target user' do
      before :each do
        login_as user
      end

      it 'should reject if the current password is incorrect' do
        put "/api/v1/users/#{user.id}", {current_password: 'WrongPassword', password: 'NewPassword', password_confirmation: 'NewPassword'}
        expect(response.status).to eq(403)
      end

      it 'should reject if the passwords don\'t match' do
        put "/api/v1/users/#{user.id}", {current_password: 'TestPassword', password: 'NewPassword', password_confirmation: 'Different Password'}
        expect(response.status).to eq(422)
      end

      it 'should change the password when all is correct' do
        put "/api/v1/users/#{user.id}", {current_password: 'TestPassword', password: 'NewPassword', password_confirmation: 'NewPassword'}
        expect(response).to be_success
      end
    end

    context 'as a different user' do
      before :each do
        login_as other_user
      end

      it 'should reject in all cases' do
        put "/api/v1/users/#{user.id}", {current_password: 'TestPassword', password: 'NewPassword', password_confirmation: 'NewPassword'}
        expect(response.status).to eq(403)
      end
    end

    context 'as an admin' do
      before :each do
        login_as admin_user
      end

      it 'should succeed but not change password of other user' do
        put "/api/v1/users/#{user.id}", {current_password: 'TestPassword', password: 'NewPassword', password_confirmation: 'NewPassword'}
        expect(response).to be_success
      end
    end
  end
end