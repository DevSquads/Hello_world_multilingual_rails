# locale hash key cannot be an integer,
# added "m_" to each id for locale ids
def mission_id_to_locale_id(id)
  "m_#{id}"
end