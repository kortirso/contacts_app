class ContactsBox extends React.Component {

    constructor() {
        super();
        this.state = {
            contactId: 0
        }
    }

    _showContact(contactId) {
        this.setState({contactId: contactId});
    }

    render () {
        let contactInfo;
        if (this.state.contactId > 0) {
            contactInfo = <ContactInfo token={this.props.token} contact_id={this.state.contactId} />
        }
        else {
            contactInfo = <ContactsWelcome />
        }

        return (
            <div>
                <div className='columns small-12 medium-3 left_side'>
                    <Contacts token={this.props.token} showContact={this._showContact.bind(this)} />
                </div>
                <div className='columns small-12 medium-9 right_side'>
                    { contactInfo }
                </div>
            </div>
        );
    }
}

