class Contacts extends React.Component {

    constructor() {
        super();
        this.state = {
            contactsList: [],
            activeId: 0
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

    _selectContact(contactId) {
        this.setState({activeId: contactId});
        this.props.showContact(contactId);
    }

    _prepareContactsList() {
        return this.state.contactsList.map((contact) => {
            return (
                <Contact name={contact.name} contactId={contact.id} activeId={this.state.activeId} key={contact.id} selectContact={this._selectContact.bind(this)} />
            );
        });
    }

    render () {
        const contacts = this._prepareContactsList();
        return (
            <div className='contacts'>
                {contacts}
            </div>
        );
    }
}

