# Sidekiq Outbox pattern

based on discussions and documents such as this

* https://developers.redhat.com/articles/2021/07/30/avoiding-dual-writes-event-driven-applications#
* https://shopify.engineering/high-availability-background-jobs

## Demonstration

### Happy Case

```shell
make
make sidekiq
make sidekiq-web
make count
    ["User", 0, []]
    ["EmailSend", 0, []]
    ["Outbox", 0, []]
make demo
make count
    ["User",
     1,
     [#<User:0x00000001353333b8
       id: 1,
       name: "Michael",
       created_at: 2022-02-10 10:13:22.166987 UTC>]]
    ["EmailSend", 0, []]
    ["Outbox",
     1,
     [#<Outbox:0x00000001353706f0
       id: 1,
       model_type: "User",
       model_id: 1,
       event: "email_send",
       created_at: 2022-02-10 10:13:22.175317 UTC>]]

# wait 5 seconds
make count
    ["User",
     1,
     [#<User:0x000000014cbf90f8
       id: 1,
       name: "Michael",
       created_at: 2022-02-10 10:13:22.166987 UTC>]]
    ["EmailSend",
     1,
     [#<EmailSend:0x000000014cc6bd88
       id: 1,
       user_id: 1,
       created_at: 2022-02-10 10:13:28.314095 UTC>]]
    ["Outbox", 0, []]
```

A User is created and an email sent 5 seconds later

### Error thrown mid transaction

As the user create and outbox write is in a transaction.

```shell
# run sidekiqin error mid transaction mode
SIDEKIQ_MID_TRANSACTION_ERROR=1 make sidekiq

# create a user
DEMO_ARG=Tilly bundle exec ruby -I . -e 'require "worker_demo"; WorkerDemo.perform_async(ENV.fetch("DEMO_ARG"))'
```

Nothing will be created and the job will keep throwing an error, until the DB comes back up again.

```shell
# run sidekiq normally
make sidekiq

# kick off the job

# soon the user will be created
make count

# and later the email will be sent
```

### Error thrown pre job scheduling

Throw error between the DB writing the User record and Sidekiq/Redis writing
the job record to send an email. A dual-write problem. In this case also
writing to an outbox table prevents a dual write and alows a clean up job to
run jobs that were missed. 

```shell
# run sidekiq with error thrown
SIDEKIQ_PRE_JOB_ERROR=1 make sidekiq

# make demo with a custom name
DEMO_ARG=Sam bundle exec ruby -I . -e 'require "worker_demo"; \
  WorkerDemo.perform_async(ENV.fetch("DEMO_ARG"))'

make count
# no jobs but there are things in the outbox
["User",
 2,
 [#<User:0x0000000127458328
   id: 1,
   name: "Michael",
   created_at: 2022-02-10 10:13:22.166987 UTC>,
  #<User:0x0000000127411158
   id: 2,
   name: "Sam",
   created_at: 2022-02-10 10:15:48.593647 UTC>]]
["EmailSend",
 1,
 [#<EmailSend:0x00000001274d2718
   id: 1,
   user_id: 1,
   created_at: 2022-02-10 10:13:28.314095 UTC>]]
["Outbox",
 1,
 [#<Outbox:0x00000001275424c8
   id: 2,
   model_type: "User",
   model_id: 2,
   event: "email_send",
   created_at: 2022-02-10 10:15:48.601865 UTC>]]
```

we can see that User Sam above has an entry in the outbox but no email is being
sent.

in sidekiq the create User job fails second time around as it is not unique and
it is removed from the queue

```shell
UNIQUE constraint failed: users.name
```

now we can still perform the email sending by clearing out the outbox

```shell
# restart sidekiq in working order
make sidekiq

# clear out the outbox - could be a regular job - assuming it is idempotent
make clear-outbox

# finally a count shows us the outbox is clear 
["User",
 2,
 [#<User:0x000000013a5e5890
   id: 1,
   name: "Michael",
   created_at: 2022-02-10 10:13:22.166987 UTC>,
  #<User:0x000000013a5b93f8
   id: 2,
   name: "Sam",
   created_at: 2022-02-10 10:15:48.593647 UTC>]]
["EmailSend",
 2,
 [#<EmailSend:0x000000013a64e278
   id: 1,
   user_id: 1,
   created_at: 2022-02-10 10:13:28.314095 UTC>,
  #<EmailSend:0x000000013a609128
   id: 2,
   user_id: 2,
   created_at: 2022-02-10 10:18:25.231846 UTC>]]
["Outbox", 0, []]
```

