class ContactsBox extends React.Component {

    constructor() {
        super();
        this.state = {
            contactsList: [],
            contactId: 0,
            mode: 'open'
        }
    }

    _fetchContactsList() {
        $.ajax({
            method: 'GET',
            url: `/api/v1/contacts.json?access_token=${this.props.token}`,
            success: (contacts) => {
                this.setState({contactsList: contacts.contacts})
            }
        });
    }

    componentWillMount() {
        this._fetchContactsList();
    }

    _showContact(contactId) {
        this.setState({contactId: contactId, mode: 'open'});
    }

    _showAddForm() {
        this.setState({mode: 'add', contactId: 0});
    }

    _addContact(name, email, phone, address, company, birthday) {
        const contact = {name, email, phone, address, company, birthday};
        $.post(`/api/v1/contacts.json?access_token=${this.props.token}`, {contact})
            .success(newContactsList => {
                this.setState({contactsList: newContactsList.contacts, contactId: 0, mode: 'open'});
            })
            .error( msg => { 
                alert('Bad request');
            });
    }

    _prepareRender() {
        let contactInfo;
        if (this.state.mode == 'open') {
            if (this.state.contactId > 0) {
                contactInfo = <ContactInfo token={this.props.token} contact_id={this.state.contactId} />
            }
            else {
                contactInfo = <ContactsWelcome />
            }
        }
        else if (this.state.mode == 'add') {
            contactInfo = <ContactAdd token={this.props.token} addContact={this._addContact.bind(this)} />
        }
        return contactInfo;
    }

    render () {
        const contactInfo = this._prepareRender();
        return (
            <div>
                <div className='columns small-12 medium-3 left_side'>
                    <Contacts contactsList={this.state.contactsList} showContact={this._showContact.bind(this)} addContact={this._showAddForm.bind(this)} />
                </div>
                <div className='columns small-12 medium-9 right_side'>
                    { contactInfo }
                </div>
            </div>
        );
    }
}

