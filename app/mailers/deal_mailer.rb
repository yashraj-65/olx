class DealMailer < ApplicationMailer
    def deal_confirmed_email(deal)
        @deal = deal
        @item = deal.item
        @buyer = deal.buyer.userable
        @seller = deal.seller.userable
        mail(
            to: [@seller.email, @buyer.email],
            subject: "Deal Confirmed: #{@item.title}"
        )
    end

end
