function data = tor_get_settings(prob, tbid)
%TOR_GET_SETTINGS   Read 'tor' toolbox instance settings.
%
% Merge user-supplied toolbox settings with default values.
%
% DATA = COLL_GET_SETTINGS(PROB, TBID)
%
% PROB - Continuation problem structure.
% TBID - Toolbox instance identifier.
% DATA - Toolbox data strcture.

% Copyright (C) MINGWU LI

defaults.autonomous = false;
defaults.nOmega = 1; % number of frequency components

copts = coco_get(prob, tbid);
copts = coco_merge(defaults, copts);

data = struct();
data.autonomous = copts.autonomous;
data.nOmega = copts.nOmega;

end
