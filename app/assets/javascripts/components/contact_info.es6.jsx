class ContactInfo extends React.Component {

    constructor() {
        super();
        this.state = {
            contact: {}
        }
    }

    _fetchContact(contact_id) {
        $.ajax({
            method: 'GET',
            url: `/api/v1/contacts/${contact_id}.json?access_token=${this.props.token}`,
            success: (contact) => {
                this.setState({contact: contact.contact})
            }
        });
    }

    componentWillMount() {
        this._fetchContact(this.props.contact_id);
    }

    componentWillReceiveProps(nextProps) {
        this._fetchContact(nextProps.contact_id);
    }

    _handleEditing(event) {
        event.preventDefault();
        this.props.editContact(this.state.contact);
    }

    _handleDeleting(event) {
        event.preventDefault();
        this.props.deleteContact();
    }

    render () {
        return (
            <div className='contact_info'>
                <div className='header'>
                    <h4>{this.state.contact.name}</h4>
                    <p>Work in {this.state.contact.company}</p>
                </div>
                <div className='body'>
                    <p>Email - {this.state.contact.email}</p>
                    <p>Phone - {this.state.contact.phone}</p>
                    <p>Address - {this.state.contact.address}</p>
                    <p>Company - {this.state.contact.company}</p>
                    <p>Birthday - {this.state.contact.birthday}</p>
                    <a href='#' onClick={this._handleEditing.bind(this)} className='button'>Edit Contact</a>
                    <a href='#' onClick={this._handleDeleting.bind(this)} className='button'>Delete Contact</a>
                </div>
            </div>
        );
    }
}

