-- Requête SQL : Total des ventes par produit
SELECT
    product_name,
    SUM(sales_amount) AS total_sales
FROM
    ventes
GROUP BY
    product_name
ORDER BY
    total_sales DESC;
