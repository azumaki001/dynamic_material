select
	*
from
	Z_INVOICENOKANRI as z_InvoiceKanri



left join
	Z_YUSHUTSUKANRI as z_YushutsuKanri
on
	z_InvoiceKanri.Z_INVOICENO = z_YushutsuKanri.Z_COMMONINVOICENO



left join
	SALESQUOTATIONTABLE as SalesQuotationTable
on
	z_InvoiceKanri.Z_QUOTATIONID = SalesQuotationTable.QUOTATIONID



left join
	SALESTABLE as SalesTable
on
	z_InvoiceKanri.Z_SALESID = SalesTable.SALESID



left join
	CUSTINVOICESALESLINK as CustInvoiceSalesLink
on
	SalesTable.SALESID = CustInvoiceSalesLink.ORIGSALESID



left join
	CUSTINVOICEJOUR as CustInvoiceJour
on
	CustInvoiceSalesLink.INVOICEID = CustInvoiceJour.INVOICEID
and
	CustInvoiceSalesLink.SALESID = CustInvoiceJour.SALESID



left join
	CUSTINVOICETRANS CustInvoiceTrans
on
	CustInvoiceJour.SALESID = CustInvoiceTrans.SALESID
and
	CustInvoiceJour.INVOICEID = CustInvoiceTrans.INVOICEID
and
	CustInvoiceJour.INVOICEDATE = CustInvoiceTrans.INVOICEDATE
and
	CustInvoiceJour.NUMBERSEQUENCEGROUP = CustInvoiceTrans.NUMBERSEQUENCEGROUP



where
	z_InvoiceKanri.DATAAREAID = 'usmf'
and
	z_YushutsuKanri.DATAAREAID = 'usmf'
and
	SalesQuotationTable.DATAAREAID = 'usmf'
and
	SalesTable.DATAAREAID = 'usmf'
and
	CustInvoiceSalesLink.DATAAREAID = 'usmf'
and
	CustInvoiceJour.DATAAREAID = 'usmf'
and
	CustInvoiceTrans.DATAAREAID = 'usmf'



order by
	z_InvoiceKanri.Z_INVOICENO,
	z_InvoiceKanri.Z_QUOTATIONID