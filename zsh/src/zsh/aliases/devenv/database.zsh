alias pullDb="pg_dump -h $W_DB_HOST -U $W_DB_BP_USERNAME -p $W_DB_PORTS[1] -n broker -n meta -d $W_DB_NAME > $W_PATH/dbs/main_db.sql"
alias loadDb="psql -U $W_DB_NAME -h $W_DB_HOST -f $W_PATH/dbs/main_db.sql"
alias refreshDb="pullDb; loadDb"

alias pullQuotesDb="pg_dump -h $W_DB_HOST -U $W_DB_CT_USERNAME -p $W_DB_PORTS[1] -n carriertracker -d $W_DB_NAME > $W_PATH/dbs/quotes_db.sql"
alias loadQuotesDb="psql -U $W_DB_NAME -h $W_DB_HOST -f $W_PATH/dbs/quotes_db.sql"
alias refreshQuotesDb="pullQuotesDb; loadQuotesDb"

alias viewDevBpDb='viewDB "$W_DB_BP_USERNAME" "${W_DB_PORTS[1]}" "$W_DB_NAME" "$W_DB_HOST"'
alias viewQatBpDb='viewDB "$W_DB_BP_USERNAME" "${W_DB_PORTS[2]}" "$W_DB_NAME" "$W_DB_HOST"'
alias viewUatBpDb='viewDB "$W_DB_BP_USERNAME" "${W_DB_PORTS[3]}" "$W_DB_NAME" "$W_DB_HOST"'
alias viewProdBpDb='viewDB "$W_DB_BP_USERNAME" "${W_DB_PORTS[4]}" "$W_DB_NAME" "$W_DB_HOST"'

alias viewDevCtDb='viewDB "$W_DB_CT_USERNAME" "$W_DB_NAME" "$W_DB_HOST"'
alias viewQatCtDb='viewDB "$W_DB_CT_USERNAME" "$W_DB_NAME" "$W_DB_HOST"'
alias viewUatCtDb='viewDB "$W_DB_CT_USERNAME" "$W_DB_NAME" "$W_DB_HOST"'
alias viewProdCtDb='viewDB "$W_DB_CT_USERNAME" "$W_DB_NAME" "$W_DB_HOST"'
