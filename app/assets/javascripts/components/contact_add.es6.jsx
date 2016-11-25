class ContactAdd extends React.Component {

    _handleSubmit(event) {
        event.preventDefault();
        let name = this._name;
        let email = this._email;
        let phone = this._phone;
        let address = this._address;
        let company = this._company;
        let birthday = this._birthday;
        this.props.addContact(name.value, email.value, phone.value, address.value, company.value, birthday.value);
    }

    componentDidMount() {
        $(function(){ $('#birthday').fdatepicker({format: 'dd/mm/yyyy',leftArrow:'<<',rightArrow:'>>'}); });
    }

    render () {
        return (
            <div className='add_contact'>
                <h4>Add Contact Form</h4>
                <div className='body'>
                    <form className='contact_form' onSubmit={this._handleSubmit.bind(this)}>
                        <div className='contact_form_fields'>
                            <input type='text' placeholder='Name' ref={(input) => this._name = input} />
                            <input type='text' placeholder='Email' ref={(input) => this._email = input} />
                            <input type='text' placeholder='Phone' ref={(input) => this._phone = input} />
                            <input type='text' placeholder='Address' ref={(input) => this._address = input} />
                            <input type='text' placeholder='Company' ref={(input) => this._company = input} />
                            <input id='birthday' type='text' placeholder='Birthday' ref={(input) => this._birthday = input} />
                        </div>
                        <div className='contact_form_actions'>
                            <button type='submit' className='button'>Save Contact</button>
                        </div>
                    </form>
                </div>
            </div>
        );
    }
}

