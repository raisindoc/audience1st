module OrdersHelper

  def link_to_order_containing(item)
    link_to item.order_id, order_path(item.order)
  end

  def deletion_warning_for(order)
    "Delete checked items" <<
      (order.purchase_medium == :credit_card ? " and issue credit card refund?" : "?")
  end

  def transfer_warning_for(order)
    "This action will transfer ALL items in the order to another patron. " <<
      "The new patron will appear to be both the purchaser and the patron holding the items. " <<
      "The order will still appear to have been processed by the same person (in this case " <<
      order.processed_by.full_name <<
      ") on the same date (" <<
      order.sold_on.to_formatted_s(:showtime) <<
      ".  Click OK to proceed, or Cancel to leave things as they are."
  end
end
