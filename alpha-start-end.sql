DROP TABLE IF EXISTS alpha_start;
DROP TABLE IF EXISTS alpha_end;

CREATE TABLE alpha_start (
    seq INTEGER,
    glyph VARCHAR
);

CREATE TABLE alpha_end (
    pos INTEGER,
    symbol VARCHAR
);

INSERT INTO alpha_start(seq, glyph)
VALUES
(1, 'a'),
(2, 'b'),
(3, 'c');


INSERT INTO alpha_end(pos, symbol)
VALUES
(1, 'z'),
(2, 'y'),
(3, 'x');
