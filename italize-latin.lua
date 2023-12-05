-- this filter italizes all latin words. This is requirement in russian paper
--
-- prints WARN if word have mixed alphabets
--
-- bugs: if input text have words with italized latin with punctiation
-- characters, then its punctiation will be removed

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

local last_redacted = ""

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

    last_redacted = middle

    -- wrapping with italic style
    local obj = {}
    if left then
        table.insert(obj, pandoc.Str(left))
    end
    table.insert(obj, pandoc.Emph(pandoc.Str(middle)))
    if right then
        table.insert(obj, pandoc.Str(right))
    end
    return obj
end

-- the problem is in that double Emph results in non-Emph, so there we are
-- unwrapping redundant Emph's from previous turn
--
-- for now, new wrapped element matches the next after whom wrapped it, we
-- relying on it
function Emph(elem)
    local child = elem.content[1]
    if child.t == "Emph" then
        local child2 = child.content[1]
        if child2.t == "Str" then
            if child2.text == last_redacted then
                -- results in unwrapped one level of Emph
                return pandoc.Emph(child2.text)
            end
        end
    end
end

-- P.S. codeblocks and inlined code are not containing Str, so everything is
-- fine, they are not italized
