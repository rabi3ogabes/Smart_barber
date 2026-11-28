<?php

namespace App\Modules\Salon\Support;

use BaconQrCode\Renderer\Image\SvgImageBackEnd;
use BaconQrCode\Renderer\ImageRenderer;
use BaconQrCode\Renderer\RendererStyle\RendererStyle;
use BaconQrCode\Writer;

/**
 * The salon's printable QR code. Customers scan it to open the salon in the app; the app resolves
 * it through GET /salons/resolve (spec-review item 2: QR and deep link come first).
 */
final class SalonQr
{
    public static function link(string $slug): string
    {
        return 'smartbarber://salon/'.$slug;
    }

    public static function svg(string $slug, int $size = 240): string
    {
        return (new Writer(new ImageRenderer(new RendererStyle($size, 2), new SvgImageBackEnd)))->writeString(self::link($slug));
    }
}
