const { jsPDF } = require('jspdf');

const doc = new jsPDF();

// Function to add footer
const addFooter = (doc, pageNumber) => {
    doc.setFontSize(10); // Set the font size for the footer
    doc.text(
        'Sample Audit Report',
        doc.internal.pageSize.getWidth() - 50,
        doc.internal.pageSize.getHeight() - 10
    );
    doc.text(`${pageNumber}`, 20, doc.internal.pageSize.getHeight() - 10);
    doc.line(
        20,
        doc.internal.pageSize.getHeight() - 18,
        doc.internal.pageSize.getWidth() - 20,
        doc.internal.pageSize.getHeight() - 18
    ); // Draw line
};

// Title for the first page
doc.setFontSize(16); // Set font size for the title
doc.text('Automated Audit Report', 105, 105, null, null, 'center'); // Centered title

// Add content and footer for each page
for (let i = 1; i <= 3; i++) {
    if (i > 1) {
        doc.addPage(); // Add new page if it's not the first one
    }
    doc.text(`Content of page ${i}`, 10, 20); // Example content
    addFooter(doc, i); // Add footer
}

doc.save('./samples/a4.pdf');
