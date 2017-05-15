--select count(*) from order_master;  ---25018
--select count(*) from product_offer;  --- 79
--select count(*) from customer_organization; --99998
--select count(*) from reseller_organization; ---10
--select count(*) from partner_organization;  --- 1
--select count(*) from service_provider_organization;  --1
--select count(*) from language; --3
--select count(*) from base_user; --- 100009
--select count(*) from customer_user; ---104384
--select count(*) from customer_account; --- 101020
--select count(*) from usage_data_master; ---57087

------------ Notification ---------------
  -------------- **********
  begin
  declare @id int;
  Declare loop_var CURSOR LOCAL FOR (select id from synergy_order_line);
  OPEN loop_var
  FETCH NEXT FROM loop_var INTO @id
  WHILE @@FETCH_STATUS = 0
  BEGIN
      -----------------------------------
	  update synergy_order_line set renewal_notif_status=0,failed_notif_sent=0,delayed_notif_sent=0,workflow_email_sent=0,data_wipe_notif_sent=0,
      provisioned_notif_sent=0,suspend_notif_sent=0,resume_notif_sent=0,data_retn_1_notif_sent=0,data_retn_2_notif_sent=0,
	  data_retn_3_notif_sent=0 where id=@id;
      -----------------------------------
  FETCH NEXT FROM loop_var INTO @id
  END;
  CLOSE loop_var
  DEALLOCATE loop_var
  end;
  GO
  ----- *************


update adhoc_email_queue set retry_count=0,sent_count=0;


update order_notification_queue set sent_count=0,times_sent=0,retry_count=0;


update customer_invoice_details set notification_send=0,reminder_sent_count=0,discard_notification_status=0;


update order_notification_queue set sent_count=0,times_sent=0,retry_count=0;


update customer_invoice_details set notification_send=0,reminder_sent_count=0,discard_notification_status=0;

-------*************
  begin
  declare @id int;
  Declare loop_var CURSOR LOCAL FOR (select id from order_subscription_details);
  OPEN loop_var
  FETCH NEXT FROM loop_var INTO @id
  WHILE @@FETCH_STATUS = 0
  BEGIN
      -----------------------------------
	  update order_subscription_details set notification_reminder1=0,notification_reminder2=0,notification_reminder3=0,notification_renewal_status=0 where id=@id;
      -----------------------------------
  FETCH NEXT FROM loop_var INTO @id
  END;
  CLOSE loop_var
  DEALLOCATE loop_var
  end;
  GO
-------*************
--- invoiceAndPaymentNotifSchJob
update payment_reminder_settings set days_number=2;

update customer_invoice_details set due_date =getdate()+2;
---- invoicePDFGenerationJob
update customer_invoice_details set approval_status=2,pdf_generation_status=3;



------------ MP ------------------
update service_provider_organization set use_marketplace=1;

update po_marketplace set display_marketplace_allowed=1;

----update product_offer set publish_to_reseller_2=0;
---- correction for above wrong update
--update product_offer set  publish_to_reseller_2=1  where id in (select original_offer_id from product_offer  where creator_org_id not in (select org_id from reseller_organization ro join reseller_profile rp on ro.id=rp.reseller_org_id where rp.can_create_product_offer=1) and creator_org_id <>1);

-----------  versionScheduleJob

update offer_version_def set version_status=2, operation_status_id=1, applicable_from=getdate()-1;

----------- subscriptionRenewalScheduleJob 
  begin
  declare @id int;
  Declare loop_var CURSOR LOCAL FOR (select id from order_subscription_details);
  OPEN loop_var
  FETCH NEXT FROM loop_var INTO @id
  WHILE @@FETCH_STATUS = 0
  BEGIN
      -----------------------------------
	  update order_subscription_details set subscription_operation_status=0,subscription_end_date =getdate()-1 where id=@id;
      -----------------------------------
  FETCH NEXT FROM loop_var INTO @id
  END;
  CLOSE loop_var
  DEALLOCATE loop_var
  end;
  GO
  -----


----------- orderScheduleJob


----------- variousToolsScheduleJob



