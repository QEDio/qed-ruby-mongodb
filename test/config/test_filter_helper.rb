EMIT_KEY1                           = 'm_k_campaign_product'
EMIT_VALUE1                         = '1'
EMIT_KEY2                           = 'm_k_campaign_holding'
EMIT_VALUE2                         = '2'

EMIT_VALUE_DEFAULT                  = -1

EMIT_AS_URL                         = EMIT_KEY1 + "=" + EMIT_VALUE1 + "&" + EMIT_KEY2 + "=" + EMIT_VALUE2
EMIT_AS_URL_KEY1_VALUE_DEFAULT      = EMIT_KEY1 + "=" + EMIT_VALUE_DEFAULT.to_s

EMIT_KEYS_LIKE_URL_PARAMS     = [
    EMIT_KEY1 + "=" + EMIT_VALUE1,
    EMIT_KEY2 + "=" + EMIT_VALUE2
]

EMIT_KEYS_LIKE_ARRAY           = [
  [EMIT_KEY1, EMIT_VALUE1],
  [EMIT_KEY2, EMIT_VALUE2]
]

EMIT_KEYS_LIKE_HASH           = [
  {:key => EMIT_KEY1,       :value => EMIT_VALUE1},
  {:key => EMIT_KEY2,       :value => EMIT_VALUE2}
]

EMIT_KEYS_RESULTS_HASH =
  { :emit_keys  => [
      { :key    =>  "campaign_product",
        :value  =>  "1"
      },
      { :key    =>  "campaign_holding",
        :value  =>  "2"}
    ]
  }
