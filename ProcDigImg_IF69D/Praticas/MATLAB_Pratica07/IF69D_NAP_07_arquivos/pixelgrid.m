%pixelgrid Superimpose a grid along image pixel edges
%   pixelgrid superimposes a grid of pixel edges on the image in the
%   current axes. If the minimum extent of an image pixel is greater than
%   0.2 inches (approximately), then the grid is visible. When viewing an
%   image with a very high zoom factor, the grid is useful for determining
%   where each pixel is located, especially in regions where pixels have
%   the same or very similar colors.
%
%   pixelgrid(im) superimposes the grid on the specified image graphics
%   object.
%
%   pixelgrid(target) superimposes the grid on the image found within the
%   specified graphics target, which is typically a figure or axes object.
%
%   group = pixelgrid(___) returns an hggroup object containing the
%   lines used to draw the grid.
%
%   EXAMPLE
%
%   Superimpose pixel grid on color image. After zooming in, the grid
%   becomes visible.
%
%       rgb = imread("pixelgrid-sample.jpg");
%       imshow(rgb)
%       pixelgrid
%       axis([800 825 255 272])

%   Copyright 2017-2019 The MathWorks, Inc.
%   Copyright 2024 Steven L. Eddins
    
function grp_out = pixelgrid(target)
    arguments
        target (1,1) {mustBeGraphicsObject} = defaultTarget
    end

    requiresIMZM();

    if isa(target,"matlab.graphics.primitive.Image")
        im = target;
    else
        im = findobj(target,"type","image");
        if isempty(im)
            error("pixelgrid:ImageNotFoundInTarget",...
                "No image found in specified target.")
        end
    end

    ax = ancestor(im,"axes");

    % If there is already a pixel grid present, delete it before creating a
    % new one.
    existing_grid = findobj(ax, Type = "hggroup", Tag = "pixelgrid");
    if ~isempty(existing_grid)
        delete(existing_grid)
    end

    %
    % Calculate the vertices for a line object that will draw the entire
    % grid.
    %

    xdata = im.XData;
    ydata = im.YData;
    [M,N,~] = size(im.CData);

    if M > 1
        pixel_height = diff(ydata) / (M-1);
    else
        % Special case. Assume unit height.
        pixel_height = 1;
    end

    if N > 1
        pixel_width = diff(xdata) / (N-1);
    else
        % Special case. Assume unit width.
        pixel_width = 1;
    end

    y_top = ydata(1) - (pixel_height/2);
    y_bottom = ydata(2) + (pixel_height/2);
    y = linspace(y_top, y_bottom, M+1);

    x_left = xdata(1) - (pixel_width/2);
    x_right = xdata(2) + (pixel_width/2);
    x = linspace(x_left, x_right, N+1);

    % Construct xv1 and yv1 to draw all the vertical line segments. Separate
    % the line segments by NaN to avoid drawing diagonal line segments from the
    % bottom of one line to the top of the next line over.
    xv1 = NaN(1,3*numel(x));
    xv1(1:3:end) = x;
    xv1(2:3:end) = x;
    yv1 = repmat([y(1) y(end) NaN], 1, numel(x));

    % Construct xv2 and yv2 to draw all the horizontal line segments.
    yv2 = NaN(1,3*numel(y));
    yv2(1:3:end) = y;
    yv2(2:3:end) = y;
    xv2 = repmat([x(1) x(end) NaN], 1, numel(y));

    % Put all the vertices together so that they can be drawn with a single
    % call to line().
    xv = [xv1(:) ; xv2(:)];
    yv = [yv1(:) ; yv2(:)];

    %
    % Create two line objects, with contrasting colors and line styles, to
    % draw the grid. Place them into an hggroup.
    %

    grp = hggroup(...
        Parent = ax,...
        Tag = "pixelgrid",...
        Visible = false);
    % bottom_line_color = lab2rgb([40 0 0]);
    bottom_line_color = 0.3695 * [1 1 1];
    % top_line_color = lab2rgb([70 0 0]);
    top_line_color = 0.6708 * [1 1 1];

    bottom_line_width = 0.5;
    top_line_width = 0.5;

    % When creating the lines, use AlignVertexCenters to avoid antialias
    % effects that would cause some lines in the grid to appear brighter than
    % others.
    line(                              ...
        Parent = grp,                  ...
        XData = xv,                    ...
        YData = yv,                    ...
        LineWidth = bottom_line_width, ...
        Color = bottom_line_color,     ...
        LineStyle = "-",               ...
        AlignVertexCenters = "on")

    line(...
        Parent = grp,               ...
        XData = xv,                 ...
        YData = yv,                 ...
        LineWidth = top_line_width, ...
        Color = top_line_color,     ...
        LineStyle = "--",           ...
        AlignVertexCenters = "on")

    %
    % Create listeners that will update the visibility of the pixel grid in
    % response to graphics changes that affect the pixel extent.
    %
    % For information about the MarkedClean event that is used below, see
    % "Undocumented HG2 graphics events" (accessed 29-Jul-2024).
    % https://undocumentedmatlab.com/articles/undocumented-hg2-graphics-events
    %

    addlistener(ax,"MarkedClean",@(~,~) updatePixelGridVisibility(ax,im,grp));
    addlistener(im,"MarkedClean",@(~,~) updatePixelGridVisibility(ax,im,grp));

    updatePixelGridVisibility(ax,im,grp);    

    % Only return an output if requested.
    if nargout > 0
        grp_out = grp;
    end
end

function requiresIMZM()
    if isempty(which("getImagePixelExtentInches"))
        error("pixelgrid:RequiresIMZM",...
            "Pixel Grid requires the add-on " + ...
            """Image Zoom and Pan Utilities"" " + ...
            "(https://www.mathworks.com/matlabcentral/fileexchange/167316-image-zoom-level-and-pan-utilities)")
    end
end

function updatePixelGridVisibility(ax,im,grp)
    if ~(ishandle(ax) && ishandle(im) && ishandle(grp))
        return
    end

    if min(getImagePixelExtentInches(im)) > 0.2
        grp.Visible = true;
    else
        grp.Visible = false;
    end
end

function t = defaultTarget()
    r = groot;
    current_figure = r.CurrentFigure;
    if ~isempty(current_figure)
        current_axes = current_figure.CurrentAxes;
        if ~isempty(current_axes)
            t = findobj(current_axes,"type","image");
            if isempty(t)
                throwAsCaller(MException("pixelgrid:NoImage",...
                    "No image found in current axes."))
            end
        else
            throwAsCaller(MException("pixelgrid:NoAxes",...
                "No axes found in current figure."))
        end
    else
        throwAsCaller(MException("pixelgrid:NoFigure", ...
            "No figure found."));
    end
end

function mustBeGraphicsObject(target)
    if ~all(isgraphics(target))
        error("pixelgrid:InvalidTarget",...
            "Target must be a graphics object.")
    end
end