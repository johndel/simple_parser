describe ('Working app', () => {
    it ('Visit the app', () => {
        cy.visit ('http://localhost:3001/');
        cy.title().should('include', 'Parser');
        cy.get('.App-title .btn').click();
    });
});
