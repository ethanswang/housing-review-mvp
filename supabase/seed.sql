-- UIUC Housing Review — demo seed data
-- Run AFTER schema.sql.
--
-- READ THIS BEFORE LAUNCH:
--   * Property and company names are real and public. Addresses are block-level
--     and approximate. Rent figures are illustrative placeholders, NOT quotes.
--   * Company/property pairings are illustrative and have NOT been verified.
--   * EVERY review below is SYNTHETIC. No line of this text came from a tenant.
--     All rows carry is_sample = true and render with a visible badge.
--   * Before any real launch:  delete from reviews where is_sample;
--
-- Review text is deliberately kept to mundane, non-defamatory observations
-- (response times, communication, noise, value). Nothing here alleges illegal
-- conduct and no individual employee is named.

delete from reviews;
delete from properties;
delete from management_companies;

insert into management_companies (name, slug) values
  ('JSM',                 'jsm'),
  ('Bankier Apartments',  'bankier-apartments'),
  ('Roland Realty',       'roland-realty'),
  ('Green Street Realty', 'green-street-realty'),
  ('Smith Apartments',    'smith-apartments'),
  ('Core Spaces',         'core-spaces');

insert into properties (name, slug, address, neighborhood, rent_min, rent_max, bedrooms, company_id)
select v.name, v.slug, v.address, v.neighborhood, v.rent_min, v.rent_max, v.bedrooms, c.id
from (values
  ('HERE Champaign',      'here-champaign',      '300 block of E Green St, Champaign',  'Campustown',          1150, 1650, '{1,2,3,4}'::int[], 'core-spaces'),
  ('Green Street Towers', 'green-street-towers', '500 block of E Green St, Champaign',  'Campustown',           875, 1250, '{1,2,3}'::int[],   'jsm'),
  ('Lofts 54',            'lofts-54',            '50 block of E John St, Champaign',    'Campustown',           900, 1300, '{1,2,4}'::int[],   'jsm'),
  ('Bankier Apartments',  'bankier-apartments',  '400 block of E Green St, Champaign',  'Campustown',           700, 1050, '{1,2,3}'::int[],   'bankier-apartments'),
  ('Roland Realty',       'roland-realty',       '600 block of E Daniel St, Champaign', 'Campustown',           650,  975, '{1,2,3,4}'::int[], 'roland-realty'),
  ('Green Street Realty', 'green-street-realty', '100 block of N Neil St, Champaign',   'Downtown Champaign',   825, 1400, '{1,2}'::int[],     'green-street-realty'),
  ('Smith Apartments',    'smith-apartments',    '900 block of W Green St, Urbana',     'Urbana',               575,  850, '{1,2,3}'::int[],   'smith-apartments'),
  ('Campus Circle',       'campus-circle',       '200 block of E Springfield Ave',      'Engineering Campus',   700,  995, '{2,3,4}'::int[],   'roland-realty')
) as v(name, slug, address, neighborhood, rent_min, rent_max, bedrooms, company_slug)
join management_companies c on c.slug = v.company_slug;

insert into reviews (property_id, maintenance, communication, value, overall, body, lease_term, is_sample)
select p.id, v.maintenance, v.communication, v.value, v.overall, v.body, v.lease_term, true
from (values
  ('here-champaign', 4, 4, 2, 3, 'Building is genuinely nice and the gym gets used. But you are paying a real premium for that, and once you factor in parking and the mandatory fees it stopped feeling worth it to me by second semester.', '2024-25'),
  ('here-champaign', 5, 4, 3, 4, 'Front desk is responsive and packages never went missing, which was not true of my last place. Elevators get slow around class change. Would live here again if the rent had not gone up.', '2023-24'),
  ('here-champaign', 3, 2, 2, 3, 'Maintenance itself was fine when they showed up. Getting a response in the first place was the hard part. Nice unit, though, and the location is unbeatable if you are on main campus.', '2024-25'),

  ('green-street-towers', 3, 3, 4, 3, 'Reasonable for the location. Walls are thin enough that you learn your neighbors schedule. Maintenance handled a heating issue in about a week.', '2024-25'),
  ('green-street-towers', 4, 3, 4, 4, 'Solid value for how close it is to campus. Office communication is hit or miss over the summer but the building itself was well kept.', '2023-24'),
  ('green-street-towers', 2, 2, 3, 2, 'Had a recurring plumbing issue that took three separate requests to resolve. Location is the main thing keeping the rating where it is.', '2024-25'),

  ('lofts-54', 4, 4, 3, 4, 'Units are actually well laid out for four people, which is rare here. Rent is on the higher end but splitting it made it workable.', '2024-25'),
  ('lofts-54', 5, 4, 3, 4, 'Anything I reported got handled within a couple of days. No complaints about the staff. Just be ready for the price.', '2023-24'),

  ('bankier-apartments', 4, 4, 5, 4, 'Best value I found in Campustown. Nothing fancy, but things worked and when they did not someone came. Would recommend to anyone prioritizing price over amenities.', '2024-25'),
  ('bankier-apartments', 4, 5, 5, 5, 'Easy to get someone on the phone, which sounds like a low bar until you have leased somewhere else. Straightforward lease, no surprises at move out.', '2023-24'),
  ('bankier-apartments', 3, 4, 4, 4, 'Older building and it shows, but it is honest about what it is and priced accordingly. Maintenance was reasonable.', '2024-25'),
  ('bankier-apartments', 5, 4, 4, 4, 'Two years here and both were fine. Radiator heat is loud in winter. Otherwise no real complaints.', '2022-23'),

  ('roland-realty', 3, 3, 4, 3, 'Fine for the price. Kitchen was dated. Response time on requests was about a week in my experience.', '2024-25'),
  ('roland-realty', 2, 2, 3, 2, 'Communication was the weak point. Multiple emails went unanswered and I ended up walking into the office to get anything done.', '2024-25'),
  ('roland-realty', 4, 3, 4, 4, 'Apartment itself was in better shape than I expected from the photos. Office is slow but they did get to things.', '2023-24'),

  ('green-street-realty', 4, 4, 3, 4, 'Downtown is a different vibe than Campustown and I liked it. Quieter, more restaurants, longer walk to engineering. Building was well maintained.', '2024-25'),
  ('green-street-realty', 5, 5, 3, 4, 'Genuinely responsive management, which I did not expect. Pricier than campus for the same square footage but I would sign again.', '2023-24'),

  ('smith-apartments', 4, 4, 5, 4, 'Cheapest decent place I toured. Urbana side so plan around the bus. Maintenance was quick and the office actually answers.', '2024-25'),
  ('smith-apartments', 3, 4, 5, 4, 'Great price and no nonsense. Unit was clean at move in. Bus dependency is the real tradeoff, not the apartment.', '2023-24'),
  ('smith-apartments', 4, 3, 4, 4, 'Good experience overall. Laundry situation is shared and gets busy on weekends.', '2024-25'),

  ('campus-circle', 3, 3, 4, 3, 'Convenient if your classes are all engineering. Parking was tighter than advertised. Maintenance was average.', '2024-25'),
  ('campus-circle', 4, 3, 4, 4, 'Good setup for a group of three or four. Communication over breaks was slow but nothing went wrong that mattered.', '2023-24')
) as v(property_slug, maintenance, communication, value, overall, body, lease_term)
join properties p on p.slug = v.property_slug;
