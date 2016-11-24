class Contact extends React.Component {

    _handleSelect(event) {
        event.preventDefault;
        let contactId = this.props.contactId;
        this.props.selectContact(contactId);
    }

    render () {
        let contactClass = 'contact';
        if (this.props.activeId == this.props.contactId) {
            contactClass = 'contact active'
        }

        return (
            <div className={contactClass} onClick={this._handleSelect.bind(this)}>
                <p className='name'>{this.props.name}</p>
            </div>
        );
    }
}
