class Contacts extends React.Component {

    constructor() {
        super();
        this.state = {
            activeId: 0
        }
    }

    _handleAdding(event) {
        event.preventDefault();
        this.props.addContact();
        this.setState({activeId: 0});
    }

    _selectContact(contactId) {
        this.setState({activeId: contactId});
        this.props.showContact(contactId);
    }

    _prepareContactsList() {
        return this.props.contactsList.map((contact) => {
            return (
                <Contact name={contact.name} contactId={contact.id} activeId={this.state.activeId} key={contact.id} selectContact={this._selectContact.bind(this)} />
            );
        });
    }

    render () {
        const contacts = this._prepareContactsList();
        return (
            <div className='contacts'>
                <a href='#' onClick={this._handleAdding.bind(this)} className='button'>Add Contact</a>
                {contacts}
            </div>
        );
    }
}

