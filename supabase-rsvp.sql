-- Cole este código no Supabase: SQL Editor > New query > Run
-- Uma tabela única serve para todos os convites (a coluna "convite" separa cada um).
create table if not exists public.convites_rsvp (
  id          bigint generated always as identity primary key,
  convite     text        not null,           -- ex.: 'samuel-9-anos'
  nome        text        not null,
  vai         boolean     not null,           -- true = vai, false = não vai
  adultos     int         not null default 0,
  criancas    int         not null default 0,
  mensagem    text,
  created_at  timestamptz not null default now()
);

alter table public.convites_rsvp enable row level security;

-- O convidado (chave anon) só pode ENVIAR respostas; ninguém de fora consegue ler a lista.
drop policy if exists "convidado envia rsvp" on public.convites_rsvp;
create policy "convidado envia rsvp" on public.convites_rsvp
  for insert to anon
  with check (
    char_length(nome) between 2 and 60
    and adultos between 0 and 10 and criancas between 0 and 10
    and (mensagem is null or char_length(mensagem) <= 300)
  );

grant insert on public.convites_rsvp to anon;
