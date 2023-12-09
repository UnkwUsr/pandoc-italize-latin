-- this filter italizes all latin words. This is requirement in russian paper
--
-- prints WARN if word have mixed alphabets
--
-- bugs: if input text have words with italized latin with punctuation
-- characters, then its punctuation will be removed

---@diagnostic disable-next-line: undefined-global
local pandoc = pandoc

local function has_latin(text)
    if text:match("%a") then
        local no_ascii = text:gsub("%g+", "")
        if #no_ascii ~= 0 then
            print(
                "[italize-latin] WARN: word mix latin and non-latin: '"
                    .. text
                    .. "'"
            )
        end
        return true
    else
        return false
    end
end

local function split_by_borders_punctuation(text)
    local regex_left = "^%p+"
    local regex_right = "%p+$"
    local left = text:match(regex_left)
    local right = text:match(regex_right)
    local middle = text:gsub(regex_left, ""):gsub(regex_right, "")
    return left, middle, right
end

function Str(elem)
    local text = elem.text
    local left, middle, right = split_by_borders_punctuation(text)
    -- print(
    --     ("'" .. (left or "") .. "'" .. " ")
    --         .. ("'" .. (middle or "") .. "'" .. " ")
    --         .. ("'" .. (right or "") .. "'")
    -- )

    -- skipping non latin and punctiation-only, just don't touch them
    if not middle or not has_latin(middle) then
        return
    end

    -- wrapping with italic style
    local obj = {}
    if left then
        table.insert(obj, pandoc.Str(left))
    end
    table.insert(obj, pandoc.Emph(pandoc.Str(middle)))
    if right then
        table.insert(obj, pandoc.Str(right))
    end
    return obj, false
end

function Emph(elem)
    -- don't traverse into existing Emph's because then it will double-Emph,
    -- and then they are negates each other, which means no-Emph. So, we don't
    -- want un-Emph those latin words that was manually set in source text
    return elem, false
end

function Link(elem)
    -- don't traverse into links, we don't want to italize them
    return elem, false
end

function Div(elem)
    -- don't traverse into references section
    -- (still not sure should it be, but ok)
    if elem.identifier == "refs" and elem.classes[1] == "references" then
        return elem, false
    end
end

-- P.S. codeblocks and inlined code are not containing Str, so everything is
-- fine, they are not italized

local filter = {
    traverse = "topdown",
    Div = Div,
    Link = Link,
    Emph = Emph,
    Str = Str,
}
return { filter }
