class ContactEdit extends React.Component {

    _handleSubmit(event) {
        event.preventDefault();
        let name = this._name;
        let email = this._email;
        let phone = this._phone;
        let address = this._address;
        let company = this._company;
        let birthday = this._birthday;
        this.props.updateContact(name.value, email.value, phone.value, address.value, company.value, birthday.value);
    }

    componentDidMount() {
        $(function(){ $('#birthday').fdatepicker({format: 'dd/mm/yyyy',leftArrow:'<<',rightArrow:'>>'}); });
    }

    render () {
        return (
            <div className='add_contact'>
                <h4>Edit Contact Form</h4>
                <div className='body'>
                    <form className='contact_form' onSubmit={this._handleSubmit.bind(this)}>
                        <div className='contact_form_fields'>
                            <input type='text' placeholder='Name' ref={(input) => this._name = input} defaultValue={this.props.contact.name} />
                            <input type='text' placeholder='Email' ref={(input) => this._email = input} defaultValue={this.props.contact.email} />
                            <input type='text' placeholder='Phone' ref={(input) => this._phone = input} defaultValue={this.props.contact.phone} />
                            <input type='text' placeholder='Address' ref={(input) => this._address = input} defaultValue={this.props.contact.address} />
                            <input type='text' placeholder='Company' ref={(input) => this._company = input} defaultValue={this.props.contact.company} />
                            <input id='birthday' type='text' placeholder='Birthday' ref={(input) => this._birthday = input} defaultValue={this.props.contact.birthday} />
                        </div>
                        <div className='contact_form_actions'>
                            <button type='submit' className='button'>Update Contact</button>
                        </div>
                    </form>
                </div>
            </div>
        );
    }
}

