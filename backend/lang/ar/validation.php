<?php

/*
| Arabic validation messages for the rules used so far. Rules not listed here fall back
| to English (APP_FALLBACK_LOCALE); add them as new rules are used.
*/
return [
    'accepted' => 'يجب قبول :attribute.',
    'array' => 'يجب أن يكون :attribute قائمة.',
    'boolean' => 'يجب أن تكون قيمة :attribute صحيحة أو خاطئة.',
    'confirmed' => 'تأكيد :attribute غير متطابق.',
    'date' => ':attribute ليس تاريخاً صالحاً.',
    'digits' => 'يجب أن يتكون :attribute من :digits أرقام.',
    'email' => 'يجب أن يكون :attribute بريداً إلكترونياً صالحاً.',
    'exists' => ':attribute المحدد غير صالح.',
    'image' => 'يجب أن يكون :attribute صورة.',
    'in' => ':attribute المحدد غير صالح.',
    'integer' => 'يجب أن يكون :attribute عدداً صحيحاً.',
    'max' => [
        'array' => 'يجب ألا يحتوي :attribute على أكثر من :max عناصر.',
        'file' => 'يجب ألا يتجاوز حجم :attribute :max كيلوبايت.',
        'numeric' => 'يجب ألا تتجاوز قيمة :attribute :max.',
        'string' => 'يجب ألا يتجاوز :attribute :max حرفاً.',
    ],
    'mimes' => 'يجب أن يكون :attribute ملفاً من نوع: :values.',
    'min' => [
        'array' => 'يجب أن يحتوي :attribute على :min عناصر على الأقل.',
        'file' => 'يجب ألا يقل حجم :attribute عن :min كيلوبايت.',
        'numeric' => 'يجب ألا تقل قيمة :attribute عن :min.',
        'string' => 'يجب ألا يقل :attribute عن :min أحرف.',
    ],
    'numeric' => 'يجب أن يكون :attribute رقماً.',
    'password' => [
        'letters' => 'يجب أن يحتوي :attribute على حرف واحد على الأقل.',
        'mixed' => 'يجب أن يحتوي :attribute على حرف كبير وحرف صغير على الأقل.',
        'numbers' => 'يجب أن يحتوي :attribute على رقم واحد على الأقل.',
        'symbols' => 'يجب أن يحتوي :attribute على رمز واحد على الأقل.',
        'uncompromised' => 'ظهرت :attribute في تسريب بيانات. يرجى اختيار :attribute مختلفة.',
    ],
    'regex' => 'صيغة :attribute غير صحيحة.',
    'required' => 'حقل :attribute مطلوب.',
    'size' => [
        'string' => 'يجب أن يتكون :attribute من :size حرفاً.',
    ],
    'string' => 'يجب أن يكون :attribute نصاً.',
    'unique' => ':attribute مستخدم مسبقاً.',
    'url' => 'صيغة :attribute غير صحيحة.',

    'custom' => [
        'phone' => [
            'regex' => 'أدخل رقم الجوال بالصيغة الدولية، مثل ‎+97455123456.',
        ],
    ],

    'attributes' => [
        'email' => 'البريد الإلكتروني',
        'password' => 'كلمة المرور',
        'phone' => 'رقم الجوال',
        'code' => 'الرمز',
        'name' => 'الاسم',
        'locale' => 'اللغة',
        'device_name' => 'اسم الجهاز',
        'refresh_token' => 'رمز التحديث',
        'challenge_token' => 'رمز التحقق',
        'selection_token' => 'رمز الاختيار',
        'salon' => 'الصالون',
        'branch' => 'الفرع',
        'fcm_token' => 'رمز الإشعارات',
        'platform' => 'المنصة',
        'app' => 'التطبيق',
    ],
];
