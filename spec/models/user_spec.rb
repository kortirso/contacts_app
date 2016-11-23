RSpec.describe User, type: :model do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should have_many :contacts }

    describe 'User' do
        let(:user) { create :user }

        it 'should be valid' do
            expect(user).to be_valid
        end

        it 'should be invalid when sign up with existed email' do
            expect { create :user, email: user.email }.to raise_error(ActiveRecord::RecordInvalid)
        end
    end

    describe 'methods' do
        context '.check_contact_email' do
            let(:email) { 'some_mail@mail.com' }
            let!(:contact) { create :contact }

            context 'for new contacts' do
                it 'should return true if users contacts does not have email of new contact' do
                    expect(contact.user.check_contact_email(nil, email)).to eq true
                end

                it 'should return false if users contacts have email of new contact' do
                    expect(contact.user.check_contact_email(nil, contact.email)).to eq false
                end
            end

            context 'for existed contacts' do
                let!(:another_contact) { create :contact, user: contact.user }

                it 'should return true if users contacts does not have email of current contact' do
                    expect(contact.user.check_contact_email(contact.id, contact.email)).to eq true
                end

                it 'should return false if users contacts have email of current contact' do
                    expect(contact.user.check_contact_email(contact.id, another_contact.email)).to eq false
                end
            end
        end
    end
end
