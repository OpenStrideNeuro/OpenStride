function tremorTest(app, data, fs, name)

    data = rmmissing(data);
    x1 = data{:,2};

    if any(ismissing(x1(end)))
        x1(end) = [];
    end
    if length(x1) < 625
        fprintf('⚠️ Skipped %s — Not enough samples for full PSD (has %d, needs ≥625).\n', name, length(x1));
        return;
    end


    psdSmoothN = 1;   % 1 = OFF, 2/3/5/7... = smoother (display only)

    % --- Preprocess signal (NO time-domain movmean) ---
    x1 = x1(isfinite(x1));
    x1 = detrend(x1);

    % === Welch settings ===
    winLen   = 4*fs;                       % 4 s window
    win      = hann(winLen);               % Hann window
    noverlap = round(0.9 * numel(win));    % 90% overlap
    nfft     = 4*fs;                       % NFFT = 4*Fs

    % === Full-signal PSD (RAW, for tremor score) ===
    [px_raw, pf1] = pwelch(x1, win, noverlap, nfft, fs);

    % semilogy safety for RAW (also used for tremor score indexing)
    pos = px_raw(px_raw > 0 & isfinite(px_raw));
    if isempty(pos)
        tiny = realmin;
    else
        tiny = max(min(pos) * 1e-3, realmin);
    end
    px_raw(~isfinite(px_raw) | px_raw <= 0) = tiny;

    % Frequency-band indices (with boundary padding)
    freq_indices = find(pf1 > app.lowerTremorFrequency.Value & pf1 < app.higherTremorFrequency.Value);
    if isempty(freq_indices) || freq_indices(1) <= 1 || freq_indices(end) >= length(pf1)
        fprintf('⚠️ Skipped %s — tremor band indices invalid for PSD grid.\n', name);
        return;
    end
    desired_indices = [freq_indices(1)-1; freq_indices; freq_indices(end)+1];

    % === Tremor score uses RAW PSD (NOT smoothed) ===
    valuescare = px_raw(desired_indices);

    logy = zeros(length(desired_indices),1);
    logy(1) = valuescare(1);
    mult = valuescare(1) / valuescare(end);
    for k = 2:length(desired_indices)
        logy(k) = valuescare(1) * ((1 / mult)^(1 / (length(desired_indices) - 1)))^k;
    end
    tremval = sum(valuescare - logy);

    % === PSD visualization uses DISPLAY-smoothed PSD ===
    px_plot = px_raw;
    if psdSmoothN > 1
        px_plot = movmean(px_plot, psdSmoothN);
        px_plot(~isfinite(px_plot) | px_plot <= 0) = tiny;
    end

    resultFigure = figure('Visible','off');
    semilogy(pf1, px_plot);
    xlim([0 40]);
    xlabel('Frequency (Hz)'); ylabel('Power');
    title(sprintf('PSD - %s (PSD movmean=%d)', name, psdSmoothN));
    set(gcf,'Color','white'); grid on;

    % === Per-5-second segment analysis (RAW for score, optional plot smoothing not used) ===
    segmentLen  = 5*fs;
    numSegments = floor(length(x1) / segmentLen);
    tremvals = zeros(1, numSegments);

    for j = 1:numSegments
        segment = x1((j-1)*segmentLen + 1 : j*segmentLen);

        [px_seg_raw, ~] = pwelch(segment, win, noverlap, nfft, fs);

        % safety
        pos2 = px_seg_raw(px_seg_raw > 0 & isfinite(px_seg_raw));
        if isempty(pos2)
            tiny2 = realmin;
        else
            tiny2 = max(min(pos2) * 1e-3, realmin);
        end
        px_seg_raw(~isfinite(px_seg_raw) | px_seg_raw <= 0) = tiny2;

        v = px_seg_raw(17:83);   % keep your original indexing

        l = zeros(67,1); l(1) = v(1);
        m = v(1)/v(end);
        for k = 2:67
            l(k) = v(1) * ((1 / m)^(1 / 66))^k;
        end
        tremvals(j) = sum(v - l);
    end

    % === Save results ===
    resultPath = fullfile(app.resultStoragePath,'Tremor');
    result = sprintf('Number of 5sec segment in data file:%d \nOverall tremor score: %f', numSegments, tremval);

    name1 = ['Tremor_', name];
    writeTextToFile(resultPath, name1, result);

    name2 = ['PowerSpectralDensity_', name];
    saveFigureAtPath(resultPath, name2, resultFigure);

end
