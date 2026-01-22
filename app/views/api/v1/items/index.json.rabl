node(:pagination) { @pagination }

child(@items => "products") do
  extends "api/v1/items/_item"
end