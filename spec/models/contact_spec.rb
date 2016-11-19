RSpec.describe Contact, type: :model do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :user_id }
    it { should belong_to :user }

    it 'should be valid' do
        contact = create :contact

        expect(contact).to be_valid
    end
end
