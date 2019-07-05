----------金額確認画面用----------
select
	z_InvoiceKanri.Z_INVOICENO,
	z_InvoiceKanri.Z_OYAINVOICENO,
	CustInvoiceJour.SALESID,
	CustInvoiceJour.CURRENCYCODE,
	custInvoiceTrans.LINENUM,
	custInvoiceTrans.ITEMID,
	custInvoiceTrans.NAME,
	custInvoiceTrans.QTY,
	custInvoiceTrans.SALESUNIT,
	custInvoiceTrans.SALESPRICE,
	custInvoiceTrans.DISCPERCENT,
	custInvoiceTrans.LINEAMOUNT,
	CustInvoiceJour.INVOICEAMOUNT,
	sub_Qry.max_lineNum,
	sub_Qry.sum_InvoiceAmount


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
 CUSTINVOICEJOUR as CustInvoiceJour
on
 SalesTable.SALESID = CustInvoiceJour.SALESID


inner join
	(
	select
		max(custInvoiceJour.INVOICEID) as max_InvoiceId,
		max(custInvoiceTrans.LINENUM) as max_lineNum,
		sum(custInvoiceJour.INVOICEAMOUNT) as sum_InvoiceAmount

	from
		CUSTINVOICEJOUR as custInvoiceJour


	left join
		CUSTINVOICETRANS as custInvoiceTrans
	on
		custInvoiceJour.INVOICEID = custInvoiceTrans.INVOICEID


	where
		custInvoiceJour.DATAAREAID = 'usmf'
	and
		custInvoiceTrans.DATAAREAID = 'usmf'

		and custInvoiceJour.salesid = '000786'

	group by
		custInvoiceJour.SALESID
	) sub_Qry
on
	CustInvoiceJour.INVOICEID = sub_Qry.max_InvoiceId


inner join
	CUSTINVOICETRANS as custInvoiceTrans
on
	custInvoiceTrans.INVOICEID = sub_Qry.max_InvoiceId


where
	z_InvoiceKanri.DATAAREAID = 'usmf'
and
	z_YushutsuKanri.DATAAREAID = 'usmf'
and
	SalesQuotationTable.DATAAREAID = 'usmf'
and
	SalesTable.DATAAREAID = 'usmf'
and
	CustInvoiceJour.DATAAREAID = 'usmf'
and
	custInvoiceTrans.DATAAREAID = 'usmf'


and
	z_InvoiceKanri.Z_OYAINVOICENO = 'O0001'

order by
 z_InvoiceKanri.Z_INVOICENO,
 custInvoiceTrans.LINENUM;