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

    _checkWork() {
        let data;
        if (this.state.contact.company != '') {
            data = <p>Work at {this.state.contact.company}</p>;
        }
        return data;
    }

    _checkPhone() {
        return <p><img src='assets/icons/phone.png' />{this.state.contact.phone}</p>;
    }

    _checkAddress() {
        return <p><img src='assets/icons/address.png' />{this.state.contact.address}</p>;
    }

    _checkBirthday() {
        let years;
        if (this.state.contact.years >= 0) {
            years = <span> ({this.state.contact.years} years old)</span>;
        }
        return <p><img src='assets/icons/birthday.png' />{this.state.contact.birthday}{years}</p>;
    }

    _prepareContactInfo() {
        return (
            <div className='body'>
                <p><img src='assets/icons/email.png' />{this.state.contact.email}</p>
                {this._checkPhone()}
                {this._checkAddress()}
                {this._checkBirthday()}
                <a href='#' onClick={this._handleEditing.bind(this)} className='button'>Edit Contact</a>
                <a href='#' onClick={this._handleDeleting.bind(this)} className='button'>Delete Contact</a>
            </div>
        );
    }

    render () {
        const body = this._prepareContactInfo();
        return (
            <div className='contact_info'>
                <div className='header'>
                    <h4>{this.state.contact.name}</h4>
                    {this._checkWork()}
                </div>
                {body}
            </div>
        );
    }
}

