RSpec.describe Identity, type: :model do
    it { should belong_to :user }
    it { should validate_presence_of :uid }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :user_id }

    it 'should be valid' do
        identity = create :identity

        expect(identity).to be_valid
    end

    describe 'methods' do
        context '.find_for_oauth' do
            let!(:identity) { create :identity }

            it 'should returns identity if it exists' do
                expect(Identity.find_for_oauth({ uid: identity.uid, provider: identity.provider })).to eq identity
            end

            it 'should returns nil if identity doew not exist' do
                expect(Identity.find_for_oauth({ uid: '', provider: '' })).to eq nil
            end
        end
    end
end
