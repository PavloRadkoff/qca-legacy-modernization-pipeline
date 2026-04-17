<?php

declare(strict_types=1);

namespace Enterprise\ECommerce\Services;

use Enterprise\ECommerce\Models\Cart;

/**
 * Modernized via QCA Framework
 * Business logic decoupled from Database and UI layers.
 */
readonly class CartPricingService
{
    private const FLOAT VIP_DISCOUNT_RATE = 0.15;
    private const FLOAT BULK_DISCOUNT_RATE = 0.05;
    private const FLOAT BULK_THRESHOLD = 1000.00;

    // The QCA extracted logic translated into a pure, testable function
    public function calculateFinalPrice(Cart $cart): float
    {
        if ($cart->getTotalPrice() <= 0) {
            return 0.00;
        }

        $discountRate = $this->determineDiscountRate($cart);
        $discountAmount = $cart->getTotalPrice() * $discountRate;

        return round($cart->getTotalPrice() - $discountAmount, 2);
    }

    private function determineDiscountRate(Cart $cart): float
    {
        if ($cart->isVip()) {
            return self::VIP_DISCOUNT_RATE;
        }

        if ($cart->getTotalPrice() > self::BULK_THRESHOLD) {
            return self::BULK_DISCOUNT_RATE;
        }

        return 0.00;
    }
}