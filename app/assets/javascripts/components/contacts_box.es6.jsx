class ContactsBox extends React.Component {

    constructor() {
        super();
        this.state = {
            contactsList: [],
            contact: [],
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
        this.setState({mode: 'open', contactId: contactId, contact: []});
    }

    _showAddForm() {
        this.setState({mode: 'add', contactId: 0, contact: []});
    }

    _showEditForm(contact) {
        this.setState({mode: 'edit', contactId: contact.id, contact: contact});
    }

    _addContact(name, email, phone, address, company, birthday) {
        const contact = {name, email, phone, address, company, birthday};
        $.ajax({
            method: 'POST',
            url: `/api/v1/contacts.json?access_token=${this.props.token}`,
            data: {contact},
            success: (newContactsList) => {
                this.setState({contactsList: newContactsList.contacts, contactId: 0, mode: 'open'});
            },
            error: (msg) => { 
                alert('Bad request');
            }
        });
    }

    _updateContact(name, email, phone, address, company, birthday) {
        const contact = {name, email, phone, address, company, birthday};
        $.ajax({
            method: 'PATCH',
            url: `/api/v1/contacts/${this.state.contactId}.json?access_token=${this.props.token}`,
            data: {contact},
            success: (newContactsList) => {
                this.setState({contactsList: newContactsList.contacts, contactId: this.state.contact.id, mode: 'open'});
            },
            error: (msg) => { 
                alert('Bad request');
            }
        });
    }

    _deleteContact() {
        $.ajax({
            method: 'DELETE',
            url: `/api/v1/contacts/${this.state.contactId}.json?access_token=${this.props.token}`,
            success: (newContactsList) => {
                this.setState({contactsList: newContactsList.contacts, contactId: 0, mode: 'open'});
            },
            error: (msg) => { 
                alert('Bad request');
            }
        });
    }

    _prepareRender() {
        let contactInfo;
        if (this.state.mode == 'open') {
            if (this.state.contactId > 0) {
                contactInfo = <ContactInfo token={this.props.token} contact_id={this.state.contactId} editContact={this._showEditForm.bind(this)} deleteContact={this._deleteContact.bind(this)} />
            }
            else {
                contactInfo = <ContactsWelcome />
            }
        }
        else if (this.state.mode == 'add') {
            contactInfo = <ContactAdd token={this.props.token} addContact={this._addContact.bind(this)} />
        }
        else if (this.state.mode == 'edit') {
            contactInfo = <ContactEdit contact={this.state.contact} updateContact={this._updateContact.bind(this)} />
        }
        return contactInfo;
    }

    render () {
        const contactInfo = this._prepareRender();
        return (
            <div>
                <div className='columns small-12 medium-3 left_side'>
                    <Contacts contactsList={this.state.contactsList} showContact={this._showContact.bind(this)} newContact={this._showAddForm.bind(this)} />
                </div>
                <div className='columns small-12 medium-9 right_side'>
                    { contactInfo }
                </div>
            </div>
        );
    }
}

