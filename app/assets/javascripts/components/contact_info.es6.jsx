class ContactInfo extends React.Component {

    constructor(props) {
        super();
        this.state = {
            contact: {},
            contact_id: props.contact_id
        }
    }

    _fetchContact() {
        $.ajax({
            method: 'GET',
            url: `/api/v1/contacts/${this.state.contact_id}.json?access_token=${this.props.token}`,
            success: (contact) => {
                this.setState({contact: contact.contact})
            }
        });
    }

    componentWillMount() {
        this._fetchContact();
    }

    render () {
        return (
            <div className='contact_info'>
                <div className='header'>
                    <h4>{ this.state.contact.name }</h4>
                </div>
                <div className='body'>
                    <p>Email - { this.state.contact.email }</p>
                    <p>Phone - { this.state.contact.phone }</p>
                    <p>Address - { this.state.contact.address }</p>
                    <p>Company - { this.state.contact.company }</p>
                    <p>Birthday - { this.state.contact.birthday }</p>
                </div>
            </div>
        );
    }
}

